using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Druid : BaseFighter
    {
        public Druid(int level = 9)
        {
            Level = level;
            Health = Stat(125, 161, 7, 12, 9);
            MaxHealth = Health;
            PhysicalAttack = Stat(29, 39, 2, 4, 9);
            PhysicalDefense = Stat(28, 38, 2, 4, 9);
            MagicAttack = Stat(41, 55, 4, 7, 9);
            MagicDefense = Stat(32, 42, 3, 5, 9);
            Speed = Stat(26, 36, 2, 4, 9);
            Abilities = new List<Ability>() { new Thornlash(), new Regrowth(), new Entangle() };
            CharacterType = "Druid";
            Mana = Stat(41, 60, 3, 6, 9);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Druid(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Druid(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
