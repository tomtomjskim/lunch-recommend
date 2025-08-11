import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CategoriesModule } from './categories/categories.module';
import { Category } from './entities/category.entity';
import { Food } from './entities/food.entity';
import { FoodCategory } from './entities/food-category.entity';
import { Preference } from './entities/preference.entity';
import { User } from './entities/user.entity';
import { FoodsModule } from './foods/foods.module';
import { PreferencesModule } from './preferences/preferences.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      url: process.env.DATABASE_URL,
      entities: [User, Food, Category, FoodCategory, Preference],
      synchronize: true,
    }),
    FoodsModule,
    CategoriesModule,
    PreferencesModule,
    AuthModule,
  ],
})
export class AppModule {}
