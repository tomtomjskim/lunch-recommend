import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { FoodCategory } from './food-category.entity';
import { Preference } from './preference.entity';

@Entity()
export class Food {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ nullable: true })
  imageUrl: string;

  @OneToMany(() => FoodCategory, (fc) => fc.food, { cascade: true })
  foodCategories: FoodCategory[];

  @OneToMany(() => Preference, (preference) => preference.food)
  preferences: Preference[];
}
