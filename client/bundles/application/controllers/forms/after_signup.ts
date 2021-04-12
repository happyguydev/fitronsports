import FormController from '../form';

class IAfterSignupForm extends FormController {
  public firstNameTarget: HTMLInputElement;
  public lastNameTarget: HTMLInputElement;
}
class AfterSignupController extends (FormController as typeof IAfterSignupForm) {
  public static identifier = 'after-signup';
  public static targets = ['firstName', 'lastName'];

  public connect = (): void => {
    this.setup();
    window.addEventListener('popstate', (e) => this.handleBackEvent(e));
  };

  public handleBackEvent = (e: any): void => {
    e.preventDefault();
    // alert("You have already signed up, and can not revert back!");
    if (this.firstNameTarget.value !== '' && this.lastNameTarget.value !== '') {
      console.log("first name and last name is added.");
      this.formTarget.submit();
    } else {
      console.log("trying to go back with null strings.");
      window.Turbolinks.visit('/after_signup/information', {
        action: 'replace',
      });
    }
  };
}

export default AfterSignupController;
