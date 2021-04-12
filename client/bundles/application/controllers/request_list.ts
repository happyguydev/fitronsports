import { Controller } from 'stimulus';

class IRequestListController extends Controller {
  public filterTargets: HTMLButtonElement[];
  public requestTargets: HTMLDivElement[];
}

class RequestListController extends (Controller as typeof IRequestListController) {
  public static identifier = 'request-list';
  public static targets = ['filter', 'request'];

  public connect = (): void => {
    this.activateFilter('all', true);
  };

  public filter = (event: MouseEvent): void => {
    const button = event.currentTarget as HTMLButtonElement;
    const { filter } = button.dataset;
    this.activateFilter(filter as string);
  };

  private requests = (filter: string) => {
    let visibleRequests = this.requestTargets;
    let invisibleRequests: HTMLDivElement[] = [];

    if (filter !== 'all') {
      visibleRequests = visibleRequests.filter(
        (target) => target.dataset.filter === filter
      );
      invisibleRequests = this.requestTargets.filter(
        (target) => target.dataset.filter !== filter
      );
    }

    return {
      visibleRequests,
      invisibleRequests,
    };
  };

  private activateFilter = (type: string, activated = true): void => {
    const filter = this.filterTargets.find(
      (target) => target.dataset.filter === type
    );
    this.filterTargets.forEach((target) =>
      target.classList.remove('pill--active')
    );
    if (activated) {
      filter?.classList.add('pill--active');
    } else {
      filter?.classList.remove('pill--active');
    }

    const { visibleRequests, invisibleRequests } = this.requests(type);
    visibleRequests.forEach((request, index) => {
      request.classList.remove('hidden');

      // remove previous alignment class
      request.classList.remove('request-list__item--6th');
      request.classList.remove('request-list__item--3th');
      request.classList.remove('request-list__item--2nd');

      // add class for padding-right
      if ((index + 1) % 6 === 0) {
        request.classList.add('request-list__item--6th');
      } else if ((index + 1) % 3 === 0) {
        request.classList.add('request-list__item--3th');
      } else if ((index + 1) % 2 === 0) {
        request.classList.add('request-list__item--2nd');
      }
    });

    invisibleRequests.forEach((request) => {
      request.classList.add('hidden');
    });
  };
}
export default RequestListController;
