import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Category } from '../entities/category.entity';
import { FoodCategory } from '../entities/food-category.entity';
import { Food } from '../entities/food.entity';
import { FoodsController } from './foods.controller';
import { FoodsService } from './foods.service';

@Module({
  imports: [TypeOrmModule.forFeature([Food, Category, FoodCategory])],
  controllers: [FoodsController],
  providers: [FoodsService],
})
export class FoodsModule {}
