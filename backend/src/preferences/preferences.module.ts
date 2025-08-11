import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Food } from '../entities/food.entity';
import { Preference } from '../entities/preference.entity';
import { User } from '../entities/user.entity';
import { PreferencesController } from './preferences.controller';
import { PreferencesService } from './preferences.service';

@Module({
  imports: [TypeOrmModule.forFeature([Preference, User, Food])],
  controllers: [PreferencesController],
  providers: [PreferencesService],
})
export class PreferencesModule {}
