using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class HoofStomp : Ability
    {
        public HoofStomp()
        {
            Name = "Hoof Stomp";
            FlavorText = "A powerful kick from cloven hooves.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
