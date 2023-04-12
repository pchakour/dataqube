import React from 'react';
import { Button, Menu, MenuButton, MenuItem, MenuList } from '@chakra-ui/react';
import { ChevronDownIcon } from '@chakra-ui/icons';

interface ProjectVersionSelectorProps {}

export function ProjectVersionSelector({}: ProjectVersionSelectorProps) {
  return (
    <Menu>
      <MenuButton as={Button} size='xs' rightIcon={<ChevronDownIcon />}>
        v1.2.5
      </MenuButton>
      <MenuList>
        <MenuItem>v1.2.3</MenuItem>
        <MenuItem>v1.2.4</MenuItem>
        <MenuItem>v1.2.5</MenuItem>
      </MenuList>
    </Menu>
  );
}