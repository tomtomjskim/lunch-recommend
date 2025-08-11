export class CreatePreferenceDto {
  userId: number;
  foodId: number;
  type: 'LIKE' | 'DISLIKE';
}
