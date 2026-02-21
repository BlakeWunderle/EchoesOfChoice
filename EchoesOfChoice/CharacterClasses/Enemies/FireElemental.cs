using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class FireElemental : BaseFighter
    {
        public FireElemental(int level = 10)
        {
            Level = level;
            Health = Stat(350, 430, 0, 0, 10);
            MaxHealth = Health;
            PhysicalAttack = Stat(55, 70, 0, 0, 10);
            PhysicalDefense = Stat(20, 28, 0, 0, 10);
            MagicAttack = Stat(55, 70, 0, 0, 10);
            MagicDefense = Stat(20, 28, 0, 0, 10);
            Speed = Stat(22, 32, 0, 0, 10);
            Abilities = new List<Ability>() { new MagmaBurst(), new Scorch(), new Eruption() };
            CharacterType = "Fire Elemental";
            Mana = Stat(65, 85, 0, 0, 10);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public FireElemental(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new FireElemental(this);
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
