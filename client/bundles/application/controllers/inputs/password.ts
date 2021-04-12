import { Controller } from 'stimulus';
import { css } from 'emotion';
import { isEmpty } from 'lodash';

const hintClassName = css({
  transition: 'all 200ms ease-in-out',
  display: 'flex',
  opacity: 1,
  height: 'auto',
  marginBottom: '1rem',
});

const closedClassName = css({
  opacity: 0,
  marginBottom: 0,
});

const collapsedClassName = css({ height: 0 });

class IPasswordController extends Controller {
  public inputTarget: HTMLInputElement;
  public hintsTarget: HTMLDivElement;
  public animateTarget: HTMLDivElement;
}

class PasswordController extends (Controller as typeof IPasswordController) {
  // MARK: - Targets
  public static targets = ['hints', 'input', 'meter', 'animate'];
  public static identifier = 'password';

  public connect = (): void => {
    this.inputTarget.addEventListener('focus', this.showHints);
    this.inputTarget.addEventListener('blur', this.hideHints);
    this.inputTarget.addEventListener('keyup', this.changed);
    this.animateTarget.classList.add(hintClassName);
    this.hideHints();
    this.changed();
  };

  // MARK: - Private Methods
  private hintTexts = (index: number) => {
    return this.hintsTarget.dataset.hintTexts?.split(',')[index];
  };

  private showHints = (): void => {
    this.animateTarget.classList.remove(closedClassName);
    this.animateTarget.classList.remove(collapsedClassName);
  };

  private hideHints = (): void => {
    if (!isEmpty(this.inputTarget.value)) return;
    this.animateTarget.classList.add(closedClassName);
    setTimeout(() => {
      this.animateTarget.classList.add(collapsedClassName);
    }, 200);
  };

  private getHints = (value: string) => {
    return [
      {
        message: this.hintTexts(0),
        valid: value.length >= 8,
      },
      // {
      //   message: 'Must include a special character',
      //   valid: /[!@#$%^&*()_+\-=\\[\]{};':"\\|,.<>\\/?]+/.test(value),
      // },
      // {
      //   message: 'Must include a number',
      //   valid: /\d/.test(value),
      // },
      // {
      //   message: 'Must include an uppercase character',
      //   valid: /(?=.*[A-Z])\w+/.test(value),
      // },
    ];
  };

  private changed = (): void => {
    const hints = this.getHints(this.inputTarget.value);
    this.hintsTarget.innerHTML = hints
      .map((hint) => {
        const { message, valid } = hint;
        const className = css({
          color: valid ? 'grey' : undefined,
        });

        return /* html */ `
          <li class="${className}">
            ${valid ? /* html */ `<s>${message}</s>` : message}
          </li>
        `;
      })
      .join(' ');
  };
}

export default PasswordController;
