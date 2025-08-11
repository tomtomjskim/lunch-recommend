export class CreatePollDto {
  question: string;
  options: string[];
  groupId?: string;
}
