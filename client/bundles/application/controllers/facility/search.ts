import { debounce, isEmpty } from 'lodash';
import ModalController from '../modal';
import { dispatchEvent, Events } from '../../../common/utils/events';
import { IFacility } from '../../../common/interfaces/facility';

class IFacilitySearchController extends ModalController {
  public inputTarget: HTMLInputElement;
  public resultsTarget: HTMLDivElement;
  public emptyStateTarget: HTMLDivElement;
  public emptyStateTitleTarget: HTMLDivElement;
  public clearSearchTarget: HTMLButtonElement;
}

class FacilitySearchController extends (ModalController as typeof IFacilitySearchController) {
  static targets = [
    'input',
    'results',
    'emptyState',
    'emptyStateTitle',
    'clearSearch',
  ];
  static identifier = 'facility-search';

  public facilities: IFacility[] = [];

  get query(): string {
    return this.inputTarget.value;
  }

  get requestUrl(): string {
    return `/facilities.json?query=${encodeURIComponent(this.query)}`;
  }

  connect = (): void => {
    document.addEventListener('turbolinks:before-visit', (e) => {
      const visitURL = new URL(e.data.url);
      if (visitURL.pathname === '/facilities/new') {
        this.saveCurrentURL();
      }
    });

    this.inputTarget.addEventListener('keyup', debounce(this.search, 250));
    this.inputTarget.addEventListener('keyup', () => {
      if (!isEmpty(this.query)) {
        this.clearSearchTarget.classList.remove('opacity-0');
      }
    });
    this.clearSearchTarget.classList.add('opacity-0');
    this.emptyStateTarget.classList.add('hidden');
    this.search();
  };

  private search = async (): Promise<void> => {
    this.resultsTarget.classList.remove('hidden');

    const response = await fetch(this.requestUrl);
    this.facilities = await response.json();
    const noResultsHint = document.getElementById('facility-no-results-text') as HTMLParagraphElement;

    if (isEmpty(this.facilities)) {
      this.resultsTarget.classList.add('hidden');
      this.emptyStateTarget.classList.remove('hidden');
      this.emptyStateTitleTarget.textContent = `${noResultsHint.textContent} "${this.query}"`;
    } else {
      this.emptyStateTarget.classList.add('hidden');
      this.emptyStateTitleTarget.textContent = null;
    }

    this.resultsTarget.innerHTML = this.facilities
      .map(this.renderFacility)
      .join(' ');
  };

  clearSearch = (): void => {
    this.inputTarget.value = '';
    this.search();
  };

  select = (event: MouseEvent): void => {
    const target = event.currentTarget as HTMLDivElement;
    const index = target?.dataset.index;
    if (!index) {
      return;
    }

    const facility = this.facilities[parseInt(index, 10)];
    if (facility) {
      dispatchEvent(Events.facilitySearchSelected, facility, this.element);
    }
  };
  _close = (): void => {
    dispatchEvent(Events.facilitySearchClosed, -1, this.element);
  };

  private saveCurrentURL = (): void => {
    sessionStorage.setItem('pathBeforeAddFacility', window.location.pathname);
  };

  private renderFacility = (facility: IFacility, index: number) => /* html */ `
    <button
      type="button"
      class="facility-row"
      data-action="click->facility-search#select"
      data-id="${facility.id}"
      data-index="${index}"
    >
      <div class="facility-row__title">
        ${facility.name}
      </div>
      <div class="facility-row__address">
        ${facility.display_address}
      </div>
    </button>
  `;
}

export default FacilitySearchController;
