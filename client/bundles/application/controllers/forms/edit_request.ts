import { Controller } from 'stimulus';
import { Events } from '../../../common/utils/events';

class IEditRequestForm extends Controller {
  public titleTarget: HTMLInputElement;
  public descriptionTarget: HTMLTextAreaElement;
}

class EditRequestController extends (Controller as typeof IEditRequestForm) {
  public static targets = ['title', 'description'];
  public static identifier = 'edit-request';

  private attachmentCount = 0;

  public connect = (): void => {
    window.addEventListener(Events.attachmentUpdated, this.updatedAttachments);
    this.requiredFields.forEach((field: HTMLElement): void => {
      field.addEventListener('keyup', this.validateForm);
      field.addEventListener('change', this.validateForm);
    });
    this.getAttachmentCount();

    this.validateForm();
  };

  protected validateForm = (): void => {
    const valid = this.requiredFields.every((field: HTMLInputElement) => {
      if (field.value === '') {
        return false;
      }
      return true;
    });

    this.enableAllSubmitButtons(valid && this.attachmentCount > 0);
  };

  protected get requiredFields(): Array<HTMLElement> {
    return Array.from(document.querySelectorAll(`input[aria-required="true"], textarea[aria-required="true"]`));
  };

  protected get submitButtons(): Array<HTMLElement> {
    return Array.from(document.querySelectorAll(`input[type="submit"]`));
  };

  protected enableAllSubmitButtons = (state: boolean) => {
    this.submitButtons.forEach((btn: HTMLButtonElement) => {
      btn.disabled = !state;
    });
  };

  protected getAttachmentCount = () => {
    this.attachmentCount = document.querySelectorAll('.attachment').length;
  };

  protected updatedAttachments = (e: Event) => {
    this.attachmentCount += e.detail;
    this.validateForm();
    console.log("attachment updated ...", this.attachmentCount);
  };
}

export default EditRequestController;
