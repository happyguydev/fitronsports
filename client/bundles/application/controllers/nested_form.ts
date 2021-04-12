import { Controller } from 'stimulus';

class INestedFormController extends Controller {
  public templateTarget: HTMLTemplateElement;
  public linksTarget: HTMLDivElement;
}

class NestedFormController extends (Controller as typeof INestedFormController) {
  static identifier = 'nested-form';
  static targets = ['template', 'child', 'links'];

  addAssociation = (): void => {
    const id = new Date().getTime().toString();
    const content = this.templateTarget.innerHTML.replace(
      /TEMPLATE_RECORD/g,
      id
    );
    this.linksTarget.insertAdjacentHTML('beforebegin', content);
  };
}

export default NestedFormController;
