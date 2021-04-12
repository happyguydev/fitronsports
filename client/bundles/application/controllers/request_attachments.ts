import NestedFormController from './nested_form';

class IRequestAttachmentsController extends NestedFormController {
  public uploadTarget: HTMLInputElement;
}

class RequestAttachmentsController extends (NestedFormController as typeof IRequestAttachmentsController) {
  public static identifier = 'request-attachments';

  connect = () => {
    console.log(this.element);
  };
}
export default RequestAttachmentsController;
