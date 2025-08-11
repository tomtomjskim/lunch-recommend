import { Controller, Post, Body, Get, Param, Delete } from '@nestjs/common';
import { GroupsService } from './groups.service';

@Controller('groups')
export class GroupsController {
  constructor(private readonly groupsService: GroupsService) {}

  @Post()
  create(@Body('name') name: string, @Body('ownerId') ownerId: number) {
    return this.groupsService.create(name, ownerId);
  }

  @Post('join')
  join(@Body('code') code: string, @Body('userId') userId: number) {
    return this.groupsService.join(code, userId);
  }

  @Get(':id')
  detail(@Param('id') id: string) {
    return this.groupsService.detail(+id);
  }

  @Delete(':groupId/members/:memberId')
  removeMember(
    @Param('groupId') groupId: string,
    @Param('memberId') memberId: string,
  ) {
    return this.groupsService.removeMember(+groupId, +memberId);
  }
}
