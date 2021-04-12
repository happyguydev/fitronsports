import FormController from '../form';

class ICreateRequestChooseTypeController extends FormController {
  public requestTypeTarget: HTMLInputElement;
  public requestTypeSelectTargets: HTMLButtonElement[];
}

class CreateRequestChooseTypeController extends (FormController as typeof ICreateRequestChooseTypeController) {
  static targets = ['requestType', 'requestTypeSelect'];
  static identifier = 'createRequestChooseType';

  private requestType: string;

  public setRequestType = (event: Event): void => {
    const target = event.currentTarget as HTMLButtonElement;
    const requestType = target.dataset.type;
    if (!requestType) {
      return;
    }

    this.requestTypeSelectTargets
      .filter((item) => item !== target)
      .forEach((item) => item.classList.remove('request-type--active'));

    target.classList.add('request-type--active');
    this.requestTypeTarget.value = requestType;
    this.requestType = requestType;
    this.validateForm();
  };
}

export default CreateRequestChooseTypeController;
