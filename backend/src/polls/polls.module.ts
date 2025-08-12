import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Poll } from '../entities/poll.entity';
import { PollOption } from '../entities/poll-option.entity';
import { Vote } from '../entities/vote.entity';
import { PollsService } from './polls.service';
import { PollsController } from './polls.controller';
import { VotesController } from './votes.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Poll, PollOption, Vote])],
  providers: [PollsService],
  controllers: [PollsController, VotesController],
})
export class PollsModule {}
