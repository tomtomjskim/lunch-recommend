import { DataSource } from 'typeorm';
import { Poll } from '../src/entities/poll.entity';
import { PollOption } from '../src/entities/poll-option.entity';
import { Vote } from '../src/entities/vote.entity';
import { User } from '../src/entities/user.entity';
import { Preference } from '../src/entities/preference.entity';
import { Food } from '../src/entities/food.entity';
import { FoodCategory } from '../src/entities/food-category.entity';
import { Category } from '../src/entities/category.entity';
import { PollsService } from '../src/polls/polls.service';

describe('PollsService', () => {
  let dataSource: DataSource;
  let service: PollsService;

  beforeAll(async () => {
    dataSource = new DataSource({
      type: 'sqlite',
      database: ':memory:',
      entities: [User, Poll, PollOption, Vote, Preference, Food, FoodCategory, Category],
      synchronize: true,
    });
    await dataSource.initialize();
    service = new PollsService(
      dataSource.getRepository(Poll),
      dataSource.getRepository(PollOption),
      dataSource.getRepository(Vote),
    );
  });

  afterAll(async () => {
    await dataSource.destroy();
  });

  beforeEach(async () => {
    await dataSource.synchronize(true);
  });

  it('creates poll and allows voting', async () => {
    const poll = await service.create({
      question: 'Lunch?',
      groupId: '1',
      options: ['Pizza', 'Burger'],
    });
    const userRepo = dataSource.getRepository(User);
    const voter = await userRepo.save(
      userRepo.create({ email: 'voter@test.com', nickname: 'voter', socialProvider: 'local' }),
    );
    const updated = await service.vote(poll.id, poll.options[0].id, voter);
    const option = updated?.options.find((o) => o.id === poll.options[0].id);
    expect(option?.votes).toHaveLength(1);
  });

  it('fails when voting with invalid option', async () => {
    const poll = await service.create({
      question: 'Lunch?',
      groupId: '1',
      options: ['A', 'B'],
    });
    const userRepo = dataSource.getRepository(User);
    const voter = await userRepo.save(
      userRepo.create({ email: 'voter2@test.com', nickname: 'voter2', socialProvider: 'local' }),
    );
    await expect(service.vote(poll.id, 999, voter)).rejects.toThrow('Invalid option');
  });
});
