import { Controller } from 'stimulus';

class IReportListController extends Controller {
  public filterTargets: HTMLButtonElement[];
  public reportTargets: HTMLDivElement[];
}

class ReportListController extends (Controller as typeof IReportListController) {
  public static identifier = 'report-list';
  public static targets = ['filter', 'report'];

  public connect = (): void => {
    this.activateFilter('all', true);
  };

  public filter = (event: MouseEvent): void => {
    const button = event.currentTarget as HTMLButtonElement;
    const { filter } = button.dataset;
    console.log(filter);
    this.activateFilter(filter as string);
  };

  private reports = (filter: string) => {
    let visibleReports = this.reportTargets;
    let invisibleReports: HTMLDivElement[] = [];

    if (filter !== 'all') {
      visibleReports = visibleReports.filter(
        (target) => target.dataset.filter === filter
      );
      invisibleReports = this.reportTargets.filter(
        (target) => target.dataset.filter !== filter
      );
    }

    return {
      visibleReports,
      invisibleReports,
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

    const { visibleReports, invisibleReports } = this.reports(type);
    visibleReports.forEach((report, index) => {
      report.classList.remove('hidden');

      // remove previous alignment class
      report.classList.remove('report-list__item--6th');
      report.classList.remove('report-list__item--3th');
      report.classList.remove('report-list__item--2nd');

      // add class for padding-right
      if ((index + 1) % 6 === 0) {
        report.classList.add('report-list__item--6th');
      } else if ((index + 1) % 3 === 0) {
        report.classList.add('report-list__item--3th');
      } else if ((index + 1) % 2 === 0) {
        report.classList.add('report-list__item--2nd');
      }
    });

    invisibleReports.forEach((report) => {
      report.classList.add('hidden');
    });
  };
}
export default ReportListController;
