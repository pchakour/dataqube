import { Image, Text, Button, Card, CardBody, CardFooter, Heading, Stack, Link } from '@chakra-ui/react';
import React from 'react';
import { Link as ReachLink } from '@reach/router';
import { PageTemplate } from '../../../components/PageTemplate/PageTemplate';

export function HomePage() {
  return <PageTemplate marginTop={20} select='home'>
    <Card
      direction={{ base: 'column', sm: 'row' }}
      overflow='hidden'
      variant='outline'
    >
      <Image
        objectFit='cover'
        maxW={{ base: '100%', sm: '200px' }}
        src='https://images.unsplash.com/photo-1667489022797-ab608913feeb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw5fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=800&q=60'
        alt='Caffe Latte'
      />

      <Stack>
        <CardBody>
          <Heading size='md'>Create a new project</Heading>

          <Text py='2'>
            Create a new project in order to inject data to check quality
          </Text>
        </CardBody>

        <CardFooter>
          <Button variant='solid' colorScheme='blue'>
            <Link as={ReachLink} to='/projects/create'>Create</Link>
          </Button>
        </CardFooter>
      </Stack>
    </Card>
  </PageTemplate>
}