import { Body, Controller, Get, Post, Param, UseGuards } from '@nestjs/common';
import { PollsService } from './polls.service';
import { CreatePollDto } from './dto/create-poll.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('polls')
export class PollsController {
  constructor(private readonly pollsService: PollsService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() dto: CreatePollDto) {
    return this.pollsService.create(dto);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.pollsService.findOne(parseInt(id, 10));
  }
}
