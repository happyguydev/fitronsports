import Turbolinks from 'turbolinks';
import FormController from '../form';

interface Facility {
  id: number;
}

class NewFacilityForm extends FormController {
  static identifier = 'new-facility-form';

  onSuccess = ({ id: facilityId }: Facility): boolean => {
    const pathBeforeCreateFacility = sessionStorage.getItem('pathBeforeAddFacility');
    if (pathBeforeCreateFacility) {
      Turbolinks.visit(`${pathBeforeCreateFacility}?facility_id=${facilityId}`);
    } else {
      Turbolinks.visit(`/janitors/sign_up?facility_id=${facilityId}`);
    }
    return false;
  };
}

export default NewFacilityForm;
