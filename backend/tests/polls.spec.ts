import 'reflect-metadata';
import { strict as assert } from 'assert';
import { DataSource } from 'typeorm';
import { Poll } from '../src/entities/poll.entity';
import { PollOption } from '../src/entities/poll-option.entity';
import { Vote } from '../src/entities/vote.entity';
import { User } from '../src/entities/user.entity';
import { Preference } from '../src/entities/preference.entity';
import { Food } from '../src/entities/food.entity';
import { Category } from '../src/entities/category.entity';
import { FoodCategory } from '../src/entities/food-category.entity';
import { PollsService } from '../src/polls/polls.service';

async function run() {
  const dataSource = new DataSource({
    type: 'sqlite',
    database: ':memory:',
    entities: [
      User,
      Preference,
      Food,
      Category,
      FoodCategory,
      Poll,
      PollOption,
      Vote,
    ],
    synchronize: true,
  });
  await dataSource.initialize();

  const pollRepo = dataSource.getRepository(Poll);
  const optionRepo = dataSource.getRepository(PollOption);
  const voteRepo = dataSource.getRepository(Vote);
  const userRepo = dataSource.getRepository(User);

  const service = new PollsService(pollRepo, optionRepo, voteRepo);

  const user = userRepo.create({
    email: 'user@test.com',
    nickname: 'tester',
    socialProvider: 'local',
  });
  await userRepo.save(user);

  // create
  const created = await service.create({
    question: 'Favorite lunch?',
    options: ['Pizza', 'Sushi'],
  });
  assert.ok(created.id);
  assert.equal(created.options.length, 2);

  // retrieve
  const found = await service.findOne(created.id);
  assert.ok(found);
  assert.equal(found!.options.length, 2);

  // vote
  await service.vote(found!.options[0].id, user);
  const afterVote = await service.findOne(found!.id);
  assert.equal(afterVote!.options[0].votes.length, 1);
  assert.equal(afterVote!.options[0].votes[0].user.id, user.id);

  // retract
  const voteId = afterVote!.options[0].votes[0].id;
  await service.retractVote(voteId, user);
  const afterRetract = await service.findOne(found!.id);
  assert.equal(afterRetract!.options[0].votes.length, 0);
  assert.equal(afterRetract!.options[1].votes.length, 0);

  await dataSource.destroy();
  console.log('All tests passed');
}

run().catch((e) => {
  console.error(e);
  process.exit(1);
});
