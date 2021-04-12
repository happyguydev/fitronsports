import { Attachment } from '../../common/attachments/interfaces/attachment';

export type ReportPartRate = 'good' | 'problematic' | 'bad' | '';
export enum ReportFormSteps {
  partList = 1,
  editTitle = 2,
  editPart = 3,
  signature = 4,
  promptSaveDraft = 5,
}

export interface IReportPart {
  id: string;
  title: string;
  description: string;
  rate: ReportPartRate;
  product_id: number;
  product_title: string;
  saved: boolean;
  attachments: Array<Attachment>;
  destroyed?: boolean;
}

export class ReportPart implements IReportPart {
  id: string;
  title: string;
  description: string;
  rate: ReportPartRate;
  product_id: number;
  product_title: string;
  saved: boolean;
  attachments: Array<Attachment>;
  destroyed: boolean;

  constructor() {
    this.id = '';
    this.title = '';
    this.description = '';
    this.rate = '';
    this.product_title = '';
    this.product_id = -1;
    this.saved = false;
    this.attachments = [];
    this.destroyed = false;
  }
}
