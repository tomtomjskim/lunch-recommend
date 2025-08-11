import { Body, Controller, Delete, Param, Post } from '@nestjs/common';
import { CreatePreferenceDto } from './dto/create-preference.dto';
import { PreferencesService } from './preferences.service';

@Controller('preferences')
export class PreferencesController {
  constructor(private readonly preferencesService: PreferencesService) {}

  @Post()
  create(@Body() dto: CreatePreferenceDto) {
    return this.preferencesService.create(dto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.preferencesService.remove(Number(id));
  }
}
