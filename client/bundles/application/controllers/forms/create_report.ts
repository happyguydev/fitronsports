import FormController from '../form';
import FacilitySearchController from '../facility/search';
import { IFacility } from '../../../common/interfaces/facility';
import { Events, Event } from '../../../common/utils/events';

class ICreateReportForm extends FormController {
  public searchModalTarget: HTMLDivElement;
  public facilitySearchTarget: HTMLButtonElement;
}

class CreateReportForm extends (FormController as typeof ICreateReportForm) {
  public static identifier = 'create-report';
  public static targets = ['searchModal', 'facilitySearch', 'reporTitle'];

  public get facilitySearchController(): FacilitySearchController {
    return this.application.getControllerForElementAndIdentifier(
      this.searchModalTarget,
      'facility-search'
    ) as FacilitySearchController;
  }

  public facilityIdInput = (): HTMLInputElement => {
    return document.getElementById('report_facility_id') as HTMLInputElement;
  };

  public connect = (): void => {
    this.setup();
    this.searchModalTarget.addEventListener(
      Events.facilitySearchSelected,
      this.selectFacility
    );
    this.searchModalTarget.addEventListener(
      Events.facilitySearchClosed,
      this.showWizardActions
    );
  };
  public hideWizardActions = (): void => {
    const wizardActions = document.querySelectorAll('.wizard-actions');
    wizardActions.forEach((action) => {
      action.classList.add('hidden-always');
    });
  };

  public handleTitleInput = (): void => {
    this.validateForm();
  }

  public showWizardActions = (): void => {
    const wizardActions = document.querySelectorAll('.wizard-actions');
    wizardActions.forEach((action) => {
      action.classList.remove('hidden-always');
    });
  };
  public openSearch = (): void => {
    this.hideWizardActions();
    this.facilitySearchController.open();
  };

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

  public validateForm = (): void => {
    console.log("create report validate ...");
    const titleInput = document.querySelector('#report-title') as HTMLInputElement;
    const facilitySelected = document.querySelector('#report_facility_select') as HTMLButtonElement;
    const submitButton = document.querySelector('#report-submit') as HTMLButtonElement;
    if (!titleInput || !facilitySelected) return;
    submitButton.disabled = !(titleInput.value.length > 0 && facilitySelected?.textContent?.replace(/\s/g, "").length >0);
  };
}

export default CreateReportForm;
