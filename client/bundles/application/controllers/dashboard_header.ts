import { Controller } from 'stimulus';
import ModalController from './modal';

class IDashboardHeaderController extends Controller {
  public menuTarget: HTMLDivElement;
}

class DashboardHeaderController extends (Controller as typeof IDashboardHeaderController) {
  public static identifier = 'dashboard-header';
  public static targets = ['menu'];

  get menuController(): ModalController {
    return this.application.getControllerForElementAndIdentifier(
      this.menuTarget,
      'modal'
    ) as ModalController;
  }

  openMenu = () => {
    this.menuController.open();
  };
}

export default DashboardHeaderController;
