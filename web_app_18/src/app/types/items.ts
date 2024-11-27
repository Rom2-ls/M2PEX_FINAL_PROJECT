export interface Item {
  id: string;
  name: string;
  description: string;
  price: number;
  quantity: number;
}

export interface CartItem extends Item {
  userId: string;
  quantity: number;
}
