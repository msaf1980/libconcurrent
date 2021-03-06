/*
 * Copyright 2013-2018 Fabian Groffen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @file
*
* Public header
*/


#ifndef QUEUE_H
#define QUEUE_H 1

#include <stdlib.h>

#include <concurrent/queuedef.h>

/**
 * @typedef queue
 * @brief  blocking circular queue with pthread mutex
 */
typedef struct _queue queue;

/* Allocates a new queue structure with capacity to hold size elements. */
queue* queue_new(size_t size);
/**
 * Frees up allocated resources in use by the queue.  This doesn't take
 * into account any consumers at all.  That is, the caller needs to
 * ensure noone is using the queue any more.
 */
void queue_destroy(queue *q);
/* Delete an instance of a queue (call queue_destroy) and free all items before.
 * q : Queue instance handle.
 * */
void queue_delete(queue *q, queue_freesize_func f);
/**
 * Enqueues the string pointed to by p at queue q.  If the queue is
 * full, 0 is returned. This function assumes the pointer p is a copy for this
 * queue, that is returned on dequeue, or freed when dropped.
 */
int queue_enqueue(queue *q, const char *p);
/**
 * Returns the oldest entry in the queue.  If there are no entries, NULL
 * is returned.  The caller should free the returned string.
 */
const char *queue_dequeue(queue *q);
/**
 * Returns at most len elements from the queue.  Attempts to use a
 * single lock to read a vector of elements from the queue to minimise
 * effects of locking.  Returns the number of elements stored in ret.
 * The caller is responsible for freeing elements from ret, as well as
 * making sure it is large enough to store len elements.
 */
size_t queue_dequeue_vector(const char **ret, queue *q, size_t len);
/**
 * Puts the entry p at the front of the queue, instead of the end, if
 * there is space available in the queue.  Returns 0 when no space is
 * available, non-zero otherwise.  Like queue_enqueue,
 * queue_putback assumes pointer p points to a private copy for the
 * queue.
 */
char queue_putback(queue *q, const char *p);
/**
 * Returns the (approximate) size of entries waiting to be read in the
 * queue.  The returned value cannot be taken accurate with multiple
 * readers/writers concurrently in action.  Hence it can only be seen as
 * mere hint about the state of the queue.
 */
size_t queue_len(queue *q);
/**
 * Returns the (approximate) size of free entries in the queue.  The
 * same conditions as for queue_len apply.
 */
size_t queue_freesize(queue *q);
/**
 * Returns the size of the queue.
 */
size_t queue_size(queue *q);

#endif
