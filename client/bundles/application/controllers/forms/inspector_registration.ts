import FormController from '../form';
import FacilitySearchController from '../facility/search';
import { IFacility } from '../../../common/interfaces/facility';
import { Events, Event } from '../../../common/utils/events';

class IInspectorRegistrationForm extends FormController {
  public searchModalTarget: HTMLDivElement;
  public facilitySearchTarget: HTMLButtonElement;
}

class InspectorRegistrationForm extends (FormController as typeof IInspectorRegistrationForm) {
  public static identifier = 'inspector-registration';
  public static targets = ['searchModal', 'facilitySearch'];
  public omittedFields = ['inspector[facility_name]', 'inspector[facility_id]'];

  public get facilitySearchController(): FacilitySearchController {
    return this.application.getControllerForElementAndIdentifier(
      this.searchModalTarget,
      'facility-search'
    ) as FacilitySearchController;
  }

  public facilityIdInput = (): HTMLInputElement => {
    return document.getElementById('inspector_facility_id') as HTMLInputElement;
  };

  public connect = (): void => {
    this.setup();
    this.searchModalTarget.addEventListener(
      Events.facilitySearchSelected,
      this.selectFacility
    );
    this.rehydrate();

    if (this.facilitySearchTarget.dataset.facilityId) {
      this.facilitySearchTarget.classList.remove('text-grey-500');
    }
  };

  public openSearch = (): void => {
    this.facilitySearchController.open();
    this.save();
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

export default InspectorRegistrationForm;
