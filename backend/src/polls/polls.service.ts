import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Poll } from '../entities/poll.entity';
import { PollOption } from '../entities/poll-option.entity';
import { Vote } from '../entities/vote.entity';
import { CreatePollDto } from './dto/create-poll.dto';
import { User } from '../entities/user.entity';

@Injectable()
export class PollsService {
  constructor(
    @InjectRepository(Poll) private pollRepo: Repository<Poll>,
    @InjectRepository(PollOption) private optionRepo: Repository<PollOption>,
    @InjectRepository(Vote) private voteRepo: Repository<Vote>,
  ) {}

  async create(dto: CreatePollDto): Promise<Poll> {
    const poll = this.pollRepo.create({
      question: dto.question,
      groupId: dto.groupId,
      options: dto.options.map((text) => ({ text })),
    });
    return this.pollRepo.save(poll);
  }

  async findOne(id: number): Promise<Poll> {
    return this.pollRepo.findOne({
      where: { id },
      relations: ['options', 'options.votes', 'options.votes.user'],
    });
  }

  async vote(pollId: number, optionId: number, user: User): Promise<Poll> {
    const option = await this.optionRepo.findOne({
      where: { id: optionId },
      relations: ['poll'],
    });
    if (!option || option.poll.id !== pollId) {
      throw new Error('Invalid option');
    }
    let vote = await this.voteRepo.findOne({
      where: {
        user: { id: user.id },
        option: { poll: { id: pollId } },
      },
      relations: ['option', 'option.poll', 'user'],
    });
    if (vote) {
      vote.option = option;
    } else {
      vote = this.voteRepo.create({ option, user });
    }
    await this.voteRepo.save(vote);
    return this.findOne(pollId);
  }

  async retractVote(pollId: number, user: User): Promise<void> {
    const vote = await this.voteRepo.findOne({
      where: {
        user: { id: user.id },
        option: { poll: { id: pollId } },
      },
      relations: ['option', 'option.poll', 'user'],
    });
    if (vote) {
      await this.voteRepo.remove(vote);
    }
  }
}
