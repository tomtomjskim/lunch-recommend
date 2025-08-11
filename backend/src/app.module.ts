import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CategoriesModule } from './categories/categories.module';
import { Category } from './entities/category.entity';
import { Food } from './entities/food.entity';
import { FoodCategory } from './entities/food-category.entity';
import { Preference } from './entities/preference.entity';
import { User } from './entities/user.entity';
import { Group } from './entities/group.entity';
import { GroupMember } from './entities/group-member.entity';
import { FoodsModule } from './foods/foods.module';
import { PreferencesModule } from './preferences/preferences.module';
import { AuthModule } from './auth/auth.module';
import { GroupsModule } from './groups/groups.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT || '5432', 10),
      username: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASS || 'postgres',
      database: process.env.DB_NAME || 'lunch',
      entities: [User, Food, Category, FoodCategory, Preference, Group, GroupMember],
      synchronize: true,
    }),
    FoodsModule,
    CategoriesModule,
    PreferencesModule,
    AuthModule,
    GroupsModule,
  ],
})
export class AppModule {}
