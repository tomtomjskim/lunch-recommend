import { Body, Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
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

  @UseGuards(JwtAuthGuard)
  @Get('recommended')
  recommended(@Req() req: any) {
    return this.foodsService.findRecommended(req.user.userId);
  }
}
