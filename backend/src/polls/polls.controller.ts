import {
  Body,
  Controller,
  Get,
  Post,
  Delete,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { PollsService } from './polls.service';
import { CreatePollDto } from './dto/create-poll.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { VoteDto } from './dto/vote.dto';

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

  @UseGuards(JwtAuthGuard)
  @Post(':id/vote')
  vote(
    @Param('id') id: string,
    @Body() dto: VoteDto,
    @Request() req: any,
  ) {
    return this.pollsService.vote(parseInt(id, 10), dto.optionId, req.user);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id/vote')
  async retract(@Param('id') id: string, @Request() req: any) {
    await this.pollsService.retractVote(parseInt(id, 10), req.user);
    return { success: true };
  }
}
