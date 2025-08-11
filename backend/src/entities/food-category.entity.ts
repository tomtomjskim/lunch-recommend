import { Entity, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Food } from './food.entity';
import { Category } from './category.entity';

@Entity()
export class FoodCategory {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Food, (food) => food.foodCategories)
  food: Food;

  @ManyToOne(() => Category, (category) => category.foodCategories)
  category: Category;
}
