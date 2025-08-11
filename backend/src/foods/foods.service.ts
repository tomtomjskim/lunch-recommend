import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Category } from '../entities/category.entity';
import { FoodCategory } from '../entities/food-category.entity';
import { Food } from '../entities/food.entity';
import { Preference, PreferenceType } from '../entities/preference.entity';
import { CreateFoodDto } from './dto/create-food.dto';

@Injectable()
export class FoodsService {
  constructor(
    @InjectRepository(Food)
    private readonly foodsRepo: Repository<Food>,
    @InjectRepository(Category)
    private readonly categoriesRepo: Repository<Category>,
    @InjectRepository(Preference)
    private readonly preferencesRepo: Repository<Preference>,
  ) {}

  async create(dto: CreateFoodDto): Promise<Food> {
    const food = this.foodsRepo.create({
      name: dto.name,
      imageUrl: dto.imageUrl,
    });
    if (dto.categoryIds?.length) {
      const categories = await this.categoriesRepo.find({
        where: { id: In(dto.categoryIds) },
      });
      food.foodCategories = categories.map((category) => {
        const fc = new FoodCategory();
        fc.category = category;
        return fc;
      });
    }
    return this.foodsRepo.save(food);
  }

  findRandom(): Promise<Food | null> {
    return this.foodsRepo
      .createQueryBuilder('food')
      .leftJoinAndSelect('food.foodCategories', 'fc')
      .leftJoinAndSelect('fc.category', 'category')
      .orderBy('RANDOM()')
      .getOne();
  }

  async findRecommended(userId: number): Promise<Food | null> {
    const dislikes = await this.preferencesRepo.find({
      where: { user: { id: userId }, type: PreferenceType.DISLIKE },
      relations: ['food'],
    });
    const liked = await this.preferencesRepo.find({
      where: { user: { id: userId }, type: PreferenceType.LIKE },
      relations: ['food'],
    });
    const dislikedIds = dislikes.map((p) => p.food.id);
    const likedIds = liked.map((p) => p.food.id);
    if (likedIds.length) {
      return this.foodsRepo
        .createQueryBuilder('food')
        .leftJoinAndSelect('food.foodCategories', 'fc')
        .leftJoinAndSelect('fc.category', 'category')
        .where('food.id IN (:...ids)', { ids: likedIds })
        .orderBy('RANDOM()')
        .getOne();
    }
    const qb = this.foodsRepo
      .createQueryBuilder('food')
      .leftJoinAndSelect('food.foodCategories', 'fc')
      .leftJoinAndSelect('fc.category', 'category');
    if (dislikedIds.length) {
      qb.where('food.id NOT IN (:...ids)', { ids: dislikedIds });
    }
    return qb.orderBy('RANDOM()').getOne();
  }
}
