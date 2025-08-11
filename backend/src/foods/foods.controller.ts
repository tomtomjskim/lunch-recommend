import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { CreateFoodDto } from './dto/create-food.dto';
import { FoodsService } from './foods.service';

@Controller('foods')
export class FoodsController {
  constructor(private readonly foodsService: FoodsService) {}

  @Post()
  create(@Body() dto: CreateFoodDto) {
    return this.foodsService.create(dto);
  }

  @Get('random')
  random() {
    return this.foodsService.findRandom();
  }

  @Get('recommended')
  recommended(@Query('userId') userId: string) {
    return this.foodsService.findRecommended(Number(userId));
  }
}
