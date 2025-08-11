import 'reflect-metadata';
import { strict as assert } from 'assert';
import { DataSource } from 'typeorm';
import { Group } from '../src/entities/group.entity';
import { GroupMember } from '../src/entities/group-member.entity';
import { User } from '../src/entities/user.entity';
import { Preference } from '../src/entities/preference.entity';
import { Food } from '../src/entities/food.entity';
import { Category } from '../src/entities/category.entity';
import { FoodCategory } from '../src/entities/food-category.entity';
import { GroupsService } from '../src/groups/groups.service';

async function run() {
  const dataSource = new DataSource({
    type: 'sqlite',
    database: ':memory:',
    entities: [User, Group, GroupMember, Preference, Food, Category, FoodCategory],
    synchronize: true,
  });
  await dataSource.initialize();

  const userRepo = dataSource.getRepository(User);
  const groupsRepo = dataSource.getRepository(Group);
  const membersRepo = dataSource.getRepository(GroupMember);

  const owner = userRepo.create({
    email: 'owner@test.com',
    nickname: 'owner',
    socialProvider: 'local',
  });
  const joiner = userRepo.create({
    email: 'joiner@test.com',
    nickname: 'joiner',
    socialProvider: 'local',
  });
  await userRepo.save([owner, joiner]);

  const service = new GroupsService(groupsRepo, membersRepo, userRepo);

  const group = await service.create('Lunch Group', owner.id);
  assert.ok(group.invitationCode);
  const detail1 = await service.detail(group.id);
  assert.ok(detail1);
  assert.equal(detail1!.members.length, 1);
  assert.equal(detail1!.members[0].role, 'owner');

  const member = await service.join(group.invitationCode, joiner.id);
  assert.equal(member.role, 'member');
  const detail2 = await service.detail(group.id);
  assert.ok(detail2);
  assert.equal(detail2!.members.length, 2);

  const memberToRemove = detail2!.members.find((m) => m.user.id === joiner.id);
  assert.ok(memberToRemove);
  await service.removeMember(group.id, memberToRemove!.id);
  const detail3 = await service.detail(group.id);
  assert.ok(detail3);
  assert.equal(detail3!.members.length, 1);

  await dataSource.destroy();
  console.log('All tests passed');
}

run().catch((e) => {
  console.error(e);
  process.exit(1);
});
