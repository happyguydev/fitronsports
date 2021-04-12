import FormController from '../form';

class IAccountEditPasswordForm extends FormController {
  public passwordConfirmTarget: HTMLInputElement;
}

class AccountEditPasswordForm extends (FormController as typeof IAccountEditPasswordForm) {
  public static identifier = 'edit-password';
  public static targets = ['passwordConfirm'];

  public connect = (): void => {
    this.setup();
    this.passwordConfirmTarget.addEventListener('keyup', () =>
      this.comparePasswordsInput()
    );
    const passwordHintIcons = document.querySelectorAll('.field__icon-right');
    passwordHintIcons.forEach((hintIcon) => {
      hintIcon.addEventListener('click', (e: Event): void => {
        const inputElement = e.currentTarget.parentElement.querySelector('input');
        if (!inputElement) return;
        inputElement.focus();
        if (inputElement.value === '') return;
        if (inputElement.type === 'password') {
          inputElement.type = 'text';
        } else {
          inputElement.type = 'password';
        }
      });
    });
  }

  public passwordInput = (): HTMLInputElement => {
    return document.getElementById('password-input') as HTMLInputElement;
  }

  public comparePasswordsInput = (): void => {
    if(this.passwordConfirmTarget.value !== this.passwordInput().value) {
      this.submit.disabled = true;
    }
  }
}

export default AccountEditPasswordForm;
