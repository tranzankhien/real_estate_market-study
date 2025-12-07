import { Container, Flex, Heading, Text, Card, Button, Badge } from "@radix-ui/themes";

interface PropertyDetailProps {
  propertyId: string;
  onBack: () => void;
}

export function PropertyDetail({ propertyId, onBack }: PropertyDetailProps) {
  // TODO: Query property detail từ blockchain
  // Mock data để demo
  const property = {
    id: propertyId,
    title: "Nhà 3 tầng view biển",
    description: "Nhà đẹp, vị trí thuận lợi, gần trung tâm, view biển tuyệt đẹp...",
    location: "123 Trần Hưng Đạo, Đà Nẵng",
    price: 5000000,
    area: 120,
    type: "Nhà",
    imageUrl: "https://via.placeholder.com/800x400",
    isAvailable: true,
    owner: "0xabc...",
  };

  const getPropertyTypeIcon = (type: string) => {
    switch (type) {
      case "Nhà": return "🏠";
      case "Đất": return "🌳";
      case "Căn hộ": return "🏢";
      default: return "";
    }
  };

  return (
    <Container size="3">
      <Button onClick={onBack} variant="soft" mb="4">
        ← Quay lại
      </Button>

      <Card>
        <img
          src={property.imageUrl}
          alt={property.title}
          style={{
            width: "100%",
            height: "400px",
            objectFit: "cover",
            borderRadius: "8px",
          }}
        />

        <Flex direction="column" gap="4" p="4">
          <Flex justify="between" align="center">
            <Heading size="6">{property.title}</Heading>
            {property.isAvailable && (
              <Badge color="green" size="2">Đang bán</Badge>
            )}
          </Flex>

          <Flex gap="4" wrap="wrap">
            <Flex align="center" gap="2">
              <Text size="3">
                {getPropertyTypeIcon(property.type)} <strong>{property.type}</strong>
              </Text>
            </Flex>
            <Flex align="center" gap="2">
              <Text size="3">
                📐 <strong>{property.area}m²</strong>
              </Text>
            </Flex>
            <Flex align="center" gap="2">
              <Text size="3" color="blue" weight="bold">
                💰 {property.price.toLocaleString()} IOTA
              </Text>
            </Flex>
          </Flex>

          <Flex direction="column" gap="2">
            <Text size="2" weight="bold">Địa chỉ:</Text>
            <Text size="2" color="gray">📍 {property.location}</Text>
          </Flex>

          <Flex direction="column" gap="2">
            <Text size="2" weight="bold">Mô tả:</Text>
            <Text size="2" color="gray">{property.description}</Text>
          </Flex>

          <Flex direction="column" gap="2">
            <Text size="2" weight="bold">Chủ sở hữu:</Text>
            <Text size="2" color="gray" style={{ fontFamily: "monospace" }}>
              {property.owner}
            </Text>
          </Flex>

          {property.isAvailable && (
            <Flex gap="3" mt="2">
              <Button size="3" style={{ flex: 1 }}>
                💳 Mua ngay
              </Button>
              <Button size="3" variant="soft" style={{ flex: 1 }}>
                🔒 Đặt cọc
              </Button>
            </Flex>
          )}
        </Flex>
      </Card>
    </Container>
  );
}
