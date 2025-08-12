import { DataSource } from 'typeorm';
import { Group } from '../src/entities/group.entity';
import { GroupMember } from '../src/entities/group-member.entity';
import { User } from '../src/entities/user.entity';
import { Preference } from '../src/entities/preference.entity';
import { Food } from '../src/entities/food.entity';
import { FoodCategory } from '../src/entities/food-category.entity';
import { Category } from '../src/entities/category.entity';
import { GroupsService } from '../src/groups/groups.service';

describe('GroupsService', () => {
  let dataSource: DataSource;
  let service: GroupsService;

  beforeAll(async () => {
    dataSource = new DataSource({
      type: 'sqlite',
      database: ':memory:',
      entities: [User, Group, GroupMember, Preference, Food, FoodCategory, Category],
      synchronize: true,
    });
    await dataSource.initialize();
    service = new GroupsService(
      dataSource.getRepository(Group),
      dataSource.getRepository(GroupMember),
      dataSource.getRepository(User),
    );
  });

  afterAll(async () => {
    await dataSource.destroy();
  });

  beforeEach(async () => {
    await dataSource.synchronize(true);
  });

  it('creates group successfully', async () => {
    const userRepo = dataSource.getRepository(User);
    const owner = await userRepo.save(
      userRepo.create({ email: 'owner@test.com', nickname: 'owner', socialProvider: 'local' }),
    );
    const group = await service.create('Lunch Group', owner.id);
    expect(group.invitationCode).toBeDefined();
    const detail = await service.detail(group.id);
    expect(detail?.members).toHaveLength(1);
    expect(detail?.members[0].role).toBe('owner');
  });

  it('fails to create group when owner missing', async () => {
    await expect(service.create('Lunch Group', 999)).rejects.toThrow();
  });

  it('joins group successfully', async () => {
    const userRepo = dataSource.getRepository(User);
    const owner = await userRepo.save(
      userRepo.create({ email: 'owner2@test.com', nickname: 'owner2', socialProvider: 'local' }),
    );
    const joiner = await userRepo.save(
      userRepo.create({ email: 'joiner@test.com', nickname: 'joiner', socialProvider: 'local' }),
    );
    const group = await service.create('Lunch Group', owner.id);
    const member = await service.join(group.invitationCode, joiner.id);
    expect(member.role).toBe('member');
    const detail = await service.detail(group.id);
    expect(detail?.members).toHaveLength(2);
  });

  it('fails to join with invalid invitation code', async () => {
    const userRepo = dataSource.getRepository(User);
    const joiner = await userRepo.save(
      userRepo.create({ email: 'joiner2@test.com', nickname: 'joiner2', socialProvider: 'local' }),
    );
    await expect(service.join('badcode', joiner.id)).rejects.toThrow();
  });

  it('fails to join when user missing', async () => {
    const userRepo = dataSource.getRepository(User);
    const owner = await userRepo.save(
      userRepo.create({ email: 'owner3@test.com', nickname: 'owner3', socialProvider: 'local' }),
    );
    const group = await service.create('Lunch Group', owner.id);
    await expect(service.join(group.invitationCode, 9999)).rejects.toThrow();
  });
});
