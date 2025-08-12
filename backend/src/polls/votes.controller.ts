import { Body, Controller, Delete, Param, Post, UseGuards, Request } from '@nestjs/common';
import { PollsService } from './polls.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateVoteDto } from './dto/create-vote.dto';

@Controller('votes')
export class VotesController {
  constructor(private readonly pollsService: PollsService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  cast(@Body() dto: CreateVoteDto, @Request() req) {
    return this.pollsService.vote(dto.optionId, req.user);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  async remove(@Param('id') id: string, @Request() req) {
    await this.pollsService.retractVote(parseInt(id, 10), req.user);
    return { success: true };
  }
}
