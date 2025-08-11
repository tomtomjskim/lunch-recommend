import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Food } from '../entities/food.entity';
import { Preference, PreferenceType } from '../entities/preference.entity';
import { User } from '../entities/user.entity';
import { CreatePreferenceDto } from './dto/create-preference.dto';

@Injectable()
export class PreferencesService {
  constructor(
    @InjectRepository(Preference)
    private readonly prefRepo: Repository<Preference>,
    @InjectRepository(User)
    private readonly usersRepo: Repository<User>,
    @InjectRepository(Food)
    private readonly foodsRepo: Repository<Food>,
  ) {}

  async create(dto: CreatePreferenceDto): Promise<Preference> {
    const user = await this.usersRepo.findOne({ where: { id: dto.userId } });
    const food = await this.foodsRepo.findOne({ where: { id: dto.foodId } });
    if (!user || !food) {
      throw new NotFoundException('User or Food not found');
    }
    const pref = this.prefRepo.create({
      user,
      food,
      type: dto.type as PreferenceType,
    });
    return this.prefRepo.save(pref);
  }

  async remove(id: number): Promise<void> {
    await this.prefRepo.delete(id);
  }
}
