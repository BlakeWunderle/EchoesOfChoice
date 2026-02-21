using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class DragonBreath : Ability
    {
        public DragonBreath()
        {
            Name = "Dragon Breath";
            FlavorText = "A torrent of searing flame erupts from the dragon's maw.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
