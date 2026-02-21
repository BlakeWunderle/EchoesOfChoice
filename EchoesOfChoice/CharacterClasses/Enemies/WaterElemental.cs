using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class WaterElemental : BaseFighter
    {
        public WaterElemental(int level = 10)
        {
            Level = level;
            Health = Stat(340, 420, 0, 0, 10);
            MaxHealth = Health;
            PhysicalAttack = Stat(30, 40, 0, 0, 10);
            PhysicalDefense = Stat(28, 38, 0, 0, 10);
            MagicAttack = Stat(45, 58, 0, 0, 10);
            MagicDefense = Stat(35, 45, 0, 0, 10);
            Speed = Stat(28, 38, 0, 0, 10);
            Abilities = new List<Ability>() { new TidalSurge(), new HealingRain(), new Riptide() };
            CharacterType = "Water Elemental";
            Mana = Stat(70, 90, 0, 0, 10);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 5;
        }

        public WaterElemental(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new WaterElemental(this);
        }

        public override void IncreaseLevel()
        {
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
