import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { User } from './user.entity';
import { Food } from './food.entity';

export enum PreferenceType {
  LIKE = 'LIKE',
  DISLIKE = 'DISLIKE',
}

@Entity()
export class Preference {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, (user) => user.preferences)
  user: User;

  @ManyToOne(() => Food, (food) => food.preferences)
  food: Food;

  @Column({ type: 'simple-enum', enum: PreferenceType })
  type: PreferenceType;
}
