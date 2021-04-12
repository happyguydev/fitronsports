export interface Attachment {
  id: string;
  file: File | null;
  note: string;
  fileURL?: string;
  saved?: boolean;
  destroyed?: boolean;
  blobId?: string;
}

export const MARK_ORIGINAL = '![*edited*]';
