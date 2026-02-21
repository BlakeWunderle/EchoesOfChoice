namespace EchoesOfChoice.CharacterClasses.Common
{
    public class FighterSaveData
    {
        public string ClassId { get; set; }
        public string CharacterName { get; set; }
        public bool IsUserControlled { get; set; }
        public int Level { get; set; }
        public int MaxHealth { get; set; }
        public int MaxMana { get; set; }
        public int PhysicalAttack { get; set; }
        public int PhysicalDefense { get; set; }
        public int MagicAttack { get; set; }
        public int MagicDefense { get; set; }
        public int Speed { get; set; }
        public int CritChance { get; set; }
        public int CritDamage { get; set; }
        public int DodgeChance { get; set; }
    }
}
