import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { FoodCategory } from './food-category.entity';

@Entity()
export class Category {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  name: string;

  @OneToMany(() => FoodCategory, (fc) => fc.category)
  foodCategories: FoodCategory[];
}
