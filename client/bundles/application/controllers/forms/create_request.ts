import FormController from '../form';
import FacilitySearchController from '../facility/search';
import { IFacility } from '../../../common/interfaces/facility';
import { Events, Event } from '../../../common/utils/events';

class ICreateRequestForm extends FormController {
  public searchModalTarget: HTMLDivElement;
  public facilitySearchTarget: HTMLButtonElement;
}

class CreateRequestForm extends (FormController as typeof ICreateRequestForm) {
  public static identifier = 'create-request';
  public static targets = ['searchModal', 'facilitySearch'];
  public omittedFields = ['janitor[facility_name]'];

  public get facilitySearchController(): FacilitySearchController {
    return this.application.getControllerForElementAndIdentifier(
      this.searchModalTarget,
      'facility-search'
    ) as FacilitySearchController;
  }

  public facilityIdInput = (): HTMLInputElement => {
    return document.getElementById(
      'create_request_form_facility_id'
    ) as HTMLInputElement;
  };

  public connect = (): void => {
    this.setup();
    this.searchModalTarget.addEventListener(
      Events.facilitySearchSelected,
      this.selectFacility
    );

    window.addEventListener('popstate', (e) => this.handleBackAction(e));
  };

  public handleBackAction = (e: any): void => {
    alert('Current input will be lost after going back!');
    return e.preventDefault();
  }

  public openSearch = (): void => {
    this.facilitySearchController.open();
  };

  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
  public selectFacility = (event: any): void => {
    const facility = (event as Event<IFacility>).detail as IFacility;
    const facilityIdInput = this.facilityIdInput();
    this.facilitySearchController.close();

    if (!facilityIdInput) {
      return;
    }

    this.facilitySearchTarget.value = facility.name;
    this.facilitySearchTarget.textContent = facility.name;
    this.facilitySearchTarget.classList.remove('text-grey-500');

    facilityIdInput.value = facility.id.toString();
    this.validateForm();
  };
}

export default CreateRequestForm;
