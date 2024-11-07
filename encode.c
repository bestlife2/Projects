#include "encode.h"

#define BUF_SIZE (1 << 8)

typedef struct _node {
	unsigned int	code;
	char			data[BUF_SIZE];
	struct _node*	prev;
	struct _node*	next;
} Node;

typedef struct _list {
	unsigned int	size;
	struct _node*	head;
	struct _node*	tail;
} LinkedList; // Circular Doubly Linked List

Node* create_node(unsigned int, char*);
void update_tail(LinkedList*);
void insert_front(LinkedList*, unsigned int, char*);
void insert_back(LinkedList*, unsigned int, char*);
void pop_front(LinkedList*);
void pop_back(LinkedList*);
Node* search_data(LinkedList*, char*);
LinkedList* init_dict();
void print_list(LinkedList*);

LinkedList* init_dict() {
	LinkedList* list = (LinkedList *)malloc(sizeof(LinkedList));
	list->head = list->tail = NULL;
	list->size = 0;
	char tmp[BUF_SIZE];
	memset(tmp, '\0', sizeof(char) * BUF_SIZE);
	for (unsigned int i = 0; i < 256; i++) {
		tmp[0] = (char)i;
		insert_back(list, i, tmp);
	}
	return list;	
}

void print_list(LinkedList* list) {
	Node* tmp = list->head;
	if (tmp == NULL) { printf("Empty\n"); return; }
	do {
		printf("(%d, %s)->", tmp->code, tmp->data);
		tmp = tmp->next;
	} while (tmp != list->head);
	printf("\n");
}

void free_dict(LinkedList* list) {
	while (list->size > 0) { pop_front(list); }
}

void encode(int p, int max_bit_length) {
    // TODO
	LinkedList* list = init_dict();
	//printf("Args: %s\n", bin);
	print_list(list);

	free_dict(list);
	free(list);
}

Node* create_node(unsigned int code, char* data) {
	Node* new_node = (Node *)malloc(sizeof(Node));
	new_node->code = code;
	memset(new_node->data, '\0', sizeof(char) * BUF_SIZE);
	strcpy(new_node->data, data);
	new_node->prev = NULL;
	new_node->next = NULL;
	return new_node;
}

void update_tail(LinkedList* list) {
	list->tail = list->head->prev;
	return;
}

void insert_front(LinkedList* list, unsigned int code, char* data) {
	Node* new_node = create_node(code, data);
	list->size++;
	if (list->head == NULL) {
		list->head = new_node;
		new_node->prev = new_node;
		new_node->next = new_node;
		update_tail(list);
		return;
	}
	list->head->prev->next = new_node;
	new_node->prev = list->head->prev;
	new_node->next = list->head;
	list->head->prev = new_node;

	list->head = new_node;
	return;
}

void insert_back(LinkedList* list, unsigned int code, char* data) {
	Node* new_node = create_node(code, data);
	list->size++;
	if (list->head == NULL) {
		list->head = new_node;
		new_node->prev = new_node;
		new_node->next = new_node;
		update_tail(list);
		return;
	}
	new_node->prev = list->head->prev;
	new_node->next = list->head;
	list->head->prev->next = new_node;
	list->head->prev = new_node;

	update_tail(list);
	return;
}

void pop_front(LinkedList* list) {
	if (list->head == NULL) { return; }
	list->size--;
	if (list->head == list->tail) { 
		free(list->head);
		list->head = list->tail = NULL;
		return;
	}
	Node* tmp = list->head;
	list->tail->next = list->head->next;
	list->head->next->prev = list->tail;
	list->head = list->head->next;
	free(tmp);
}

void pop_back(LinkedList* list) {
	if (list->head == NULL) { return; }
	list->size--;
	if (list->head == list->tail) { 
		free(list->head);
		list->head = list->tail = NULL;
		return;
	}
	Node* tmp = list->tail;
	list->tail->prev->next = list->head;
	list->head->prev = list->tail->prev;
	list->tail = list->tail->prev;
	free(tmp);
}

Node* search_data(LinkedList* list, char* buf) {
	Node* tmp = list->head;
	if (tmp == NULL) { return NULL; }
	do {
		if (strcmp(tmp->data, buf) == 0) { return tmp; }
		tmp = tmp->next;
	} while (tmp != list->head);
	return NULL;
}
