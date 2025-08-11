import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Group } from '../entities/group.entity';
import { GroupMember } from '../entities/group-member.entity';
import { User } from '../entities/user.entity';

@Injectable()
export class GroupsService {
  constructor(
    @InjectRepository(Group)
    private readonly groupsRepo: Repository<Group>,
    @InjectRepository(GroupMember)
    private readonly membersRepo: Repository<GroupMember>,
    @InjectRepository(User)
    private readonly usersRepo: Repository<User>,
  ) {}

  async create(name: string, ownerId: number): Promise<Group> {
    const owner = await this.usersRepo.findOneByOrFail({ id: ownerId });
    const invitationCode = Math.random().toString(36).slice(2, 8);
    const group = this.groupsRepo.create({ name, owner, invitationCode });
    await this.groupsRepo.save(group);
    const membership = this.membersRepo.create({ group, user: owner, role: 'owner' });
    await this.membersRepo.save(membership);
    return group;
  }

  async join(invitationCode: string, userId: number): Promise<GroupMember> {
    const group = await this.groupsRepo.findOneByOrFail({ invitationCode });
    const user = await this.usersRepo.findOneByOrFail({ id: userId });
    const member = this.membersRepo.create({ group, user, role: 'member' });
    return this.membersRepo.save(member);
  }

  async detail(id: number): Promise<Group | null> {
    return this.groupsRepo.findOne({
      where: { id },
      relations: ['members', 'members.user', 'owner'],
    });
  }

  async removeMember(groupId: number, memberId: number): Promise<void> {
    const member = await this.membersRepo.findOne({
      where: { id: memberId, group: { id: groupId } },
    });
    if (member) {
      await this.membersRepo.remove(member);
    }
  }
}
