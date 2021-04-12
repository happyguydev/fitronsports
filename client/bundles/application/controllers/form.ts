/* eslint-disable @typescript-eslint/no-explicit-any */
import Turbolinks from 'turbolinks';
import { Controller } from 'stimulus';
import { isEmpty, get, omit } from 'lodash';
import { NSerializeJson } from 'nserializejson';
import { convertToBracketNotation } from '../../common/utils/bracket-notiation';
import AlertController from './alert';

class IFormController extends Controller {
  public formTarget: HTMLFormElement;
  public successAlertTarget: HTMLDivElement;
  public hasSuccessAlertTarget: boolean;
  public errorAlertTarget: HTMLDivElement;
  public hasErrorAlertTarget: boolean;
}

/**
 * A stimulus controller to handle remote form submission,
 * validation and loading states.
 */
class FormController extends (Controller as typeof IFormController) {
  // MARK: - Targets
  public static targets = ['form', 'errorAlert', 'successAlert'];

  private shouldValidate = this.data.get('validate') ?? 'true';
  private redirect = this.data.get('redirect');
  private successMessage = this.data.get('success-message');

  public omittedFields: string[] = [];

  // MARK: - Getters

  protected get submit(): HTMLButtonElement | null {
    return this.element.querySelector('[type="submit"]');
  }

  protected get errorAlert(): AlertController | null {
    return this.alertController('error');
  }

  protected get successAlert(): AlertController | null {
    return this.alertController('success');
  }

  protected get requiredFields(): HTMLInputElement[] {
    return Array.from(
      this.formTarget.querySelectorAll(
        `input[aria-required="true"],
         select[aria-required="true"],
         textarea[aria-required="true"]`
      )
    );
  }

  protected get fields(): HTMLInputElement[] {
    return Array.from<HTMLInputElement>(
      this.formTarget.querySelectorAll('input, textarea, select')
    )
      .filter((input) => input.type !== 'submit')
      .filter((input) => input.type !== 'hidden');
  }

  // MARK: - Public Functions

  public connect = (): void => {
    this.setup();
  };

  public setup = (): void => {
    this.fields.forEach((input) => {
      input.addEventListener('keyup', this.validateForm);
      input.addEventListener('change', this.validateForm);
      input.addEventListener('keyup', () => this.errorAlert?.close());
      input.addEventListener('change', () => this.errorAlert?.close());
    });
    this.validateForm();
  };

  /**
   * Handles ajax:beforeSend
   */
  public beforeSend = (): void => {
    if (!this.submit) return;
    this.submit.disabled = true;
    this.submit.classList.add('button--disabled');
    this.updateFormWithErrors({});
    this.errorAlert?.close();
    this.additionalSetupBeforeSend();
  };

  /**
   * Handles ajax:failure
   * @param response {AjaxResponse}
   */
  public failure = ({ detail: [response] }: AjaxResponse): void => {
    const error: ErrorResponse = get(
      response,
      'error',
      get(response, 'errors', response)
    );
    const message = typeof error === 'string' ? error : error?.message;
    const code = get(error, 'code');

    if (/validation/i.test(code)) {
      const detail = error.detail ?? {};
      return this.errorAlert?.showList(detail);
      // return this.updateFormWithErrors(detail);
    }

    return this.errorAlert?.show(message);
  };

  /**
   * Handles ajax:completed
   */
  public completed = (): void => {
    if (!this.submit) return;
    this.submit.disabled = false;
    this.submit.classList.remove('button--disabled');
  };

  /**
   * Handles ajax:success
   */
  public success = ({ detail: [data] }: AjaxResponse): void => {
    this.clear();

    const shouldContinue = this.onSuccess(data);
    if (!shouldContinue) {
      return;
    }

    if (this.redirect) {
      if (this.redirect === 'back') {
        window.history.back();
      } else {
        Turbolinks.visit(this.redirect);
      }
    }

    this.successAlert?.show(this.successMessage ?? 'Success');
  };

  public onSuccess = (_data?: any): boolean => {
    return true;
  };

  /**
   * Serializes the form to a JSON object
   */
  public serialize = (): Record<string, any> => {
    return omit(NSerializeJson.serializeForm(this.formTarget), [
      ...this.omittedFields,
      'authenticity_token',
    ]);
  };

  /**
   * Saves the current form into session storage
   */
  public save = (persistence: 'session' | 'local' = 'session'): void => {
    const serialized = this.serialize();
    const storageKey = `f-${this.formTarget.id}`;
    if (persistence === 'session') {
      sessionStorage.setItem(storageKey, JSON.stringify(serialized));
    } else {
      localStorage.setItem(storageKey, JSON.stringify(serialized));
    }
  };

  /**
   * Clears the current form persistence
   */
  public clear = (persistence: 'session' | 'local' = 'session'): void => {
    const storageKey = `f-${this.formTarget.id}`;
    if (persistence === 'session') {
      sessionStorage.removeItem(storageKey);
    } else {
      localStorage.removeItem(storageKey);
    }
  };

  /**
   * Re-hydrates a form state
   */
  public rehydrate = (persistence: 'session' | 'local' = 'session'): void => {
    const persistedState = this.persistedState(persistence);
    if (!persistedState) {
      return;
    }

    const parsed = convertToBracketNotation(persistedState);
    Object.keys(parsed).forEach((key) => {
      const input = this.formTarget.querySelector(
        `[name="${key}"]`
      ) as HTMLInputElement;
      input.value = parsed[key];
    });
  };

  public persistedState = (
    persistence: 'session' | 'local' = 'session'
  ): Record<string, any> | null => {
    const storageKey = `f-${this.formTarget.id}`;
    const storedState =
      persistence === 'session'
        ? sessionStorage.getItem(storageKey)
        : localStorage.getItem(storageKey);

    if (!storedState) {
      return null;
    }

    try {
      return JSON.parse(storedState);
    } catch (error) {
      console.warn(
        `[form] could not parse form state with id ${this.formTarget.id}`
      );
      return null;
    }
  };

  // MARK: - Private Functions

  /**
   * Updates a form with an error object
   */
  private updateFormWithErrors = (errorsObject: Record<string, string[]>) => {
    this.fields.forEach((field) => {
      // Extract the name from the input field and convert
      // the name into dot notation
      // e.g. user[profile][name] -> user.profile.name
      const name = field.name
        .match(/\[.+?\]/g)
        ?.map((str) => str.slice(1, -1))
        .join('.');
      if (!name) return;

      // Get the errors fro this field from the dot notation key
      const errors: string[] = get(errorsObject, name, []);

      if (!isEmpty(errors)) {
        // Add the "Field--error" class
        field.parentElement?.classList.add('field--error');
      } else {
        // Remove the "Field--error" class
        field.parentElement?.classList.remove('field--error');
      }

      // Remove any existing error messages
      field.parentElement
        ?.querySelectorAll('.field__error')
        .forEach((item) => item.remove());

      // Add back the error messages
      errors.forEach((error) => {
        field.insertAdjacentHTML(
          'afterend',
          `<span class="field__error">${error}</span>`
        );
      });
    });
  };

  /**
   * Updates the form state based on simple HTML validations
   */
  protected validateForm = (): void => {
    if (!this.submit || !JSON.parse(this.shouldValidate)) return;

    const valid = this.requiredFields.every((field) => {
      const input = field as HTMLInputElement;
      if (
        input.disabled ||
        isEmpty(input.value) ||
        (input.type === 'checkbox' && !input.checked)
      ) {
        return false;
      }

      return true;
    });

    this.submit.disabled = !valid;
  };

  private alertController = (type: string): AlertController | null => {
    const target = (() => {
      switch (type) {
        case 'error':
          return this.hasErrorAlertTarget && this.errorAlertTarget;
        case 'success':
          return this.hasSuccessAlertTarget && this.successAlertTarget;
        default:
          return null;
      }
    })();

    if (!target) {
      return null;
    }

    return this.application.getControllerForElementAndIdentifier(
      target,
      'alert'
    ) as AlertController;
  };

  // MARK: - Overridable methods
  public additionalSetupBeforeSend = (): void => {
    // Empty
  };
}

export default FormController;
